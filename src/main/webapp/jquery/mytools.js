function getQueryVariable(variable)
{
    let query = window.location.search.substring(1);
    let vars = query.split("&");
    for (let i=0;i<vars.length;i++) {
        let pair = vars[i].split("=");
        if(pair[0] === variable){return pair[1];}
    }
    return false;
}

function getSysTime() {
    //判断是否在前面加0
    function getNow(s) {
        return s < 10 ? '0' + s: s;
    }

    let myDate = new Date();

    let year=myDate.getFullYear();        //获取当前年
    let month=myDate.getMonth()+1;   //获取当前月
    let date=myDate.getDate();            //获取当前日


    let h=myDate.getHours();              //获取当前小时数(0-23)
    let m=myDate.getMinutes();          //获取当前分钟数(0-59)
    let s=myDate.getSeconds();

    return year + '-' + getNow(month) + "-" + getNow(date) + " " + getNow(h) + ':' + getNow(m) + ":" + getNow(s);
}