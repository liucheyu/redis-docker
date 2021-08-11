
docker-compose中的command和entrypint設定在某個node跑兩個指令，往往都失敗。

導致能起redis但cluster沒辦法光執行docker-compose時就可以起來。

執行新增cluster的2種方式
1. 執行完docker-compose後，手動執行docker exec
2. 用dockerfile自製預設跑redis-server指令，docker-compose再額外執行redis-cli新增cluster
3. 掛入執行兩個指令的bash，增加docker-compose增加environment參數

另外一個做法是不用docker-compose，全部寫bash迴圈執行docker run把參數全部代完，還可以指定要跑幾個台
