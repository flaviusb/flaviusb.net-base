#!/bin/bash

set -e

DATETEXT=
if [[ $PUBLISHDATE != $EDITDATE ]]
then
  DATETEXT=$(cat <<END
<p>Published <span class="date">$PUBLISHDATE</span>, Edited <span class="date">$EDITDATE</span></p>
END
)
else
  DATETEXT=$(cat <<END
<p>Published <span class="date">$PUBLISHDATE</span></p>
END
)
fi
export DATETEXT
