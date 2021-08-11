redis-docker使用方式
---
執行 redisUp.sh -f[conf目錄位置] -c[自訂目錄位置] -p[起始port] -n[cluster數] -h[host ip]

不帶任何參數也可執行，此時會於終端機詢問是否要指定這些參數，enter按到底會使用預設的參數

預設參數如下
- conf目錄位置: 此執行檔位置/conf
- 自訂目錄位置: 此執行檔位置/customize
- 起始port: 自6379 port開始
- cluster數: 預設6個
- host ip: 使用docker預設bridge的ip
