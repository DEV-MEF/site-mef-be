import fs from "node:fs";
import * as Path from "node:path";


fs.writeFileSync("app.log", `LOGSTART AT ${new Date().toISOString()} \n`);

let intervalTimeout = 1000;
// let interval = setTimeout(()=>{
//     logAppend( module, "." );
// },  1000 * 10 );

export function logAppend( lModule: NodeJS.Module, message:string ){
    if( module.filename !== lModule.filename ) {
        // clearTimeout( interval );
        let filename = Path.relative( __dirname, lModule.filename );
        fs.writeFileSync("app.log", `${new Date().toISOString()} | ${filename} >> ${message}\n`, { flag: "a" });
        // interval = setTimeout(()=>{
        //     logAppend( module, "." );
        // },  intervalTimeout);
    } else {
        fs.writeFileSync("app.log", `.\n`, { flag: "a" });
        // interval = setTimeout(()=>{
        //     logAppend( module, "." );
        // },  intervalTimeout);

    }
}