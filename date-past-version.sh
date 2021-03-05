#!/bin/bash

set -e

DATETEXT=
if [[ $PUBLISHDATE != $EDITDATE ]]
then
  DATETEXT=$(cat <<END
<p>First published <span class="date">$PUBLISHDATE</span>, this version from <span class="date">$EDITDATE</span></p>
END
)
else
  DATETEXT=$(cat <<END
<p>Version from <span class="date">$PUBLISHDATE</span></p>
END
)
fi
export DATETEXT
