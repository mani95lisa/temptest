(function(dust){dust.register("admin",body_0);var blocks={"body":body_1};function body_0(chk,ctx){ctx=ctx.shiftBlocks(blocks);return chk.p("layouts/master",ctx,{}).w("<link rel=\"stylesheet\" href=\"/components/fontawesome/css/font-awesome.min.css\" /><link rel=\"stylesheet\" href=\"/css/admin.css\" />");}body_0.__dustBody=!0;function body_1(chk,ctx){ctx=ctx.shiftBlocks(blocks);return chk.p("layouts/header",ctx,{}).p("layouts/left",ctx,{}).p("layouts/right",ctx,{}).w("<script data-main=\"/js/admin\" src=\"/components/requirejs/require.js\"></script>");}body_1.__dustBody=!0;return body_0;})(dust);