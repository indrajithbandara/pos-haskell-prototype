{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE MultiParamTypeClasses #-}

-- | Listener for stats delivery

module Pos.Communication.Server.Statistics
       ( statsListeners
       ) where

import           Control.TimeWarp.Rpc      (BinaryP, MonadDialog)
import           Formatting                (build, sformat, (%))
import           System.Wlog               (logInfo)
import           Universum

import           Pos.Communication.Types   (RequestStat (..), ResponseMode,
                                            ResponseStat (..))
import           Pos.DHT                   (ListenerDHT (..), replyToNode)
import           Pos.Statistics.MonadStats (getStats)
import           Pos.Statistics.StatEntry  (StatLabel (..))
import           Pos.Statistics.Tx         (StatProcessTx)
import           Pos.WorkMode              (WorkMode)

-- | Listeners for collecting stats. Wait for 'StatProcessTx' messages.
statsListeners :: (MonadDialog BinaryP m, WorkMode ssc m) => [ListenerDHT m]
statsListeners = [ ListenerDHT $ handleStatsRequests @StatProcessTx
                 ]

handleStatsRequests :: (StatLabel l, ResponseMode ssc m) => RequestStat l -> m ()
handleStatsRequests (RequestStat id label) = do
    logInfo $ sformat ("Requested statistical data with label "%build) label
    stats <- getStats label
    replyToNode $ ResponseStat id label stats
