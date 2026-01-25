Pre-requisites:
 - pidplus.sh
 - restore.sh
 - startQuarkus.sh

To create containers with CRIU, execute script buildJ9-criu.sh
which follows the instructions in Dockerfile_restcrud_openj9_criu.
The image will be limited to 1 CPU and 256 MB.
If you want embed JITServer (Semeru Cloud Compiler) functionality
use: "buildJ9-criu.sh --jitserver"

