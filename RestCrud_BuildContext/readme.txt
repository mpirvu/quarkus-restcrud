To create containers without CRIU execute buildQuarkusJ9.sh
Requirements
  - You need the "target" directory which contains the restCrud app (copied by the script)
  - You need Dockerfile_restcrud_openj9
  - You need populate_scc.sh script if you want to embed the SCC in container
       - change postgres ip address inside
  - You can pick the OpenJ9 container from ICR: icr.io/appcafe/ibm-semeru-runtimes:open-17-jdk-ubi
    or you can build your own and modify Dockerfile_restcrud_openj9 to reflect that
  - The postgress database needs to be up and running (already done by the script)
     docker run -d --rm --name postgres --net=host restcrud-db
   
- If you provide --build-arg POPULATE_SCC=true at build time, then there will be a step to create another SCC
   layer populated with methods compiled while accessing /fruits enspoint. This is known to
   regress the time to first response for CRIU though.
