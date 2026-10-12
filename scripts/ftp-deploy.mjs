// Upload manual do tema para o FTP de produção, para teste rápido sem
// passar pelo fluxo git (PR -> merge master -> ftp-deploy.yml).
//
// Espera FTP_HOST / FTP_USERNAME / FTP_PASSWORD no ambiente (ver .env.example).
// Rodar com: node --env-file=.env scripts/ftp-deploy.mjs [dir ...]
// Sem argumentos sobe os 5 diretórios; com argumentos, só os indicados
// (o workflow usa `static` porque o FTP recusa apagar o bundle antigo).

import { Client } from "basic-ftp";
import path from "node:path";

const ALL_DIRS = ["config", "layouts", "snipplets", "static", "templates"];
const args = process.argv.slice(2).filter((a) => !a.startsWith("--"));
const unknown = args.filter((a) => !ALL_DIRS.includes(a));
if (unknown.length) {
  console.error(`Diretório(s) desconhecido(s): ${unknown.join(", ")}`);
  process.exit(1);
}
const DIRS = args.length ? args : ALL_DIRS;

const { FTP_HOST, FTP_USERNAME, FTP_PASSWORD } = process.env;

if (!FTP_HOST || !FTP_USERNAME || !FTP_PASSWORD) {
  console.error(
    "Faltam variáveis FTP_HOST / FTP_USERNAME / FTP_PASSWORD.\n" +
      "Copie .env.example para .env e preencha, depois rode:\n" +
      "  node --env-file=.env scripts/ftp-deploy.mjs"
  );
  process.exit(1);
}

const client = new Client();
client.ftp.verbose = process.argv.includes("--verbose");

try {
  await client.access({
    host: FTP_HOST,
    user: FTP_USERNAME,
    password: FTP_PASSWORD,
    secure: true,
  });

  for (const dir of DIRS) {
    console.log(`Enviando ${dir}/ ...`);
    await client.uploadFromDir(path.resolve(dir), `/${dir}`);
  }

  console.log("Deploy FTP concluído.");
} catch (err) {
  console.error("Erro no deploy FTP:", err.message ?? err);
  process.exitCode = 1;
} finally {
  client.close();
}
