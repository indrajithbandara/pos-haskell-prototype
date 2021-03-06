{-# LANGUAGE ConstraintKinds #-}

-- | Types used for communication.

module Pos.Communication.Types
       ( ResponseMode

         -- * Request types
       , module Pos.Communication.Types.Block
       , module Pos.Communication.Types.Statistics
       , module Pos.Communication.Types.SysStart
       , module Pos.Communication.Types.Tx

       , noCacheMessageNames
       ) where

import           Control.TimeWarp.Rpc               (Message (messageName), MessageName)
import           Data.Proxy                         (Proxy (..))

import           Pos.Communication.Types.Block
import           Pos.Communication.Types.Statistics
import           Pos.Communication.Types.SysStart
import           Pos.Communication.Types.Tx
import           Pos.DHT                            (MonadResponseDHT)
import           Pos.WorkMode                       (WorkMode)

-- | Constraint alias for 'WorkMode' with 'MonadResponseDHT'.
type ResponseMode ssc m = (WorkMode ssc m, MonadResponseDHT m)

-- | 'MessageName'`s that shouldn't be cached.
noCacheMessageNames :: [MessageName]
noCacheMessageNames =
    [ -- messageName (Proxy :: Proxy Block.RequestBlock)
      "RequestBlock"
    , messageName (Proxy :: Proxy SysStartRequest)
    , messageName (Proxy :: Proxy SysStartResponse)
    ]
