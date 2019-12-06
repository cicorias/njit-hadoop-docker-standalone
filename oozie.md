# Extra steps after Oozie is running;


```
oozie admin -oozie http://localhost:11000/oozie -shareliblist
```



```
Here is the solution :

hdfs dfs -put /usr/hdp/current/oozie-client/lib/*.jar /user/oozie/share/lib/*/oozie/

oozie admin -oozie http://x:11000/oozie -shareliblist oozie

oozie admin -oozie http://x:11000/oozie -sharelibupdate oozie

oozie admin -oozie http://x:11000/oozie -shareliblist oozie | grep client
```