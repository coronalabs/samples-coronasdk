module(..., package.seeall)
 
-- Stuart Carnie, manomio | in retro we trust
-- These easing functions were derived from Sparrow / http://www.sparrow-framework.org (simplified BSD license)
 
local _easeIn, _easeOut, _easeInOut, _easeOutIn
local _easeInBack, _easeOutBack, _easeInOutBack, _easeOutInBack 
local _easeInElastic, _easeOutElastic, _easeInOutElastic, _easeOutInElastic
local _easeInBounce, _easeOutBounce, _easeInOutBounce, _easeOutInBounce
 
function easeIn(t, tMax, start, delta)
        return start + (delta * _easeIn(t/tMax))
end
 
function easeOut(t, tMax, start, delta)
        return start + (delta * _easeOut(t/tMax))
end
 
function easeInOut(t, tMax, start, delta)
        return start + (delta * _easeInOut(t/tMax))
end
 
function easeOutIn(t, tMax, start, delta)
        return start + (delta * _easeOutIn(t/tMax))
end
 
function easeInBack(t, tMax, start, delta)
        return start + (delta * _easeInBack(t/tMax))
end
 
function easeOutBack(t, tMax, start, delta)
        return start + (delta * _easeOutBack(t/tMax))
end
 
function easeInOutBack(t, tMax, start, delta)
        return start + (delta * _easeInOutBack(t/tMax))
end
 
function easeOutInBack(t, tMax, start, delta)
        return start + (delta * _easeOutInBack(t/tMax))
end
 
function easeInElastic(t, tMax, start, delta)
        return start + (delta * _easeInElastic(t/tMax))
end
 
function easeOutElastic(t, tMax, start, delta)
        return start + (delta * _easeOutElastic(t/tMax))
end
 
function easeInOutElastic(t, tMax, start, delta)
        return start + (delta * _easeInOutElastic(t/tMax))
end
 
function easeOutInElastic(t, tMax, start, delta)
        return start + (delta * _easeOutInElastic(t/tMax))
end
 
function easeInBounce(t, tMax, start, delta)
        return start + (delta * _easeInBounce(t/tMax))
end
 
function easeOutBounce(t, tMax, start, delta)
        return start + (delta * _easeOutBounce(t/tMax))
end
 
function easeInOutBounce(t, tMax, start, delta)
        return start + (delta * _easeInOutBounce(t/tMax))
end
 
function easeOutInBounce(t, tMax, start, delta)
        return start + (delta * _easeOutInBounce(t/tMax))
end
 
-- local easing functions
pow = math.pow
sin = math.sin
pi = math.pi
 
_easeInBounce=function(ratio)
        return 1.0 - _easeOutBounce(1.0 - ratio)
end
 
_easeOutBounce=function(ratio)
        local s = 7.5625
        local p = 2.75
        local l
        if ratio < (1.0/p) then
                l = s * pow(ratio, 2.0)
        else
                if ratio < (2.0/p) then
                        ratio = ratio - (1.5/p)
                        l = s * pow(ratio, 2.0) + 0.75
                else
                        if ratio < (2.5/p) then
                                ratio = ratio - (2.25/p)
                                l = s * pow(ratio, 2.0) + 0.9375
                        else
                                ratio = ratio - (2.65/p)
                                l = s * pow(ratio, 2.0) + 0.984375
                        end
                end
        end
        return l
end
 
_easeInOutBounce=function(ratio)
        if (ratio < 0.5) then 
                return 0.5 * _easeInBounce(ratio*2.0)
        else
                return 0.5 * _easeOutBounce((ratio-0.5)*2.0) + 0.5
        end
end
 
_easeOutInBounce=function(ratio)
        if (ratio < 0.5) then 
                return 0.5 * _easeOutBounce(ratio*2.0)
        else
                return 0.5 * _easeInBounce((ratio-0.5)*2.0) + 0.5
        end
end
 
 
_easeInElastic=function(ratio)
        if ratio == 0 or ratio == 1.0 then return ratio end
        
        local p = 0.3
        local s = p / 4.0
        local invRatio = ratio - 1.0
        return -1 * pow(2.0, 10.0*invRatio) * sin((invRatio-s)*2*pi/p)
end
 
_easeOutElastic=function(ratio)
        if ratio == 0 or ratio == 1.0 then return ratio end
        
        local p = 0.3
        local s = p / 4.0
        return -1 * pow(2.0, -10.0*ratio) * sin((ratio-s)*2*pi/p) + 1.0
end
 
_easeInOutElastic=function(ratio)
        if (ratio < 0.5) then 
                return 0.5 * _easeInElastic(ratio*2.0)
        else
                return 0.5 * _easeOutElastic((ratio-0.5)*2.0) + 0.5
        end
end
 
_easeOutInElastic=function(ratio)
        if (ratio < 0.5) then 
                return 0.5 * _easeOutElastic(ratio*2.0)
        else
                return 0.5 * _easeInElastic((ratio-0.5)*2.0) + 0.5
        end
end
 
_easeIn=function(ratio)
        return ratio*ratio*ratio
end
 
_easeOut=function(ratio)
        local invRatio = ratio - 1.0
        return (invRatio*invRatio*invRatio) + 1.0
end
 
_easeInOut=function(ratio)
        if (ratio < 0.5) then 
                return 0.5 * _easeIn(ratio*2.0)
        else
                return 0.5 * _easeOut((ratio-0.5)*2.0) + 0.5
        end
end
 
_easeOutIn=function(ratio)
        if (ratio < 0.5) then 
                return 0.5 * _easeOut(ratio*2.0)
        else
                return 0.5 * _easeIn((ratio-0.5)*2.0) + 0.5
        end
end
 
_easeInBack=function(ratio)
        local s = 1.70158
        return pow(ratio, 2.0) * ((s + 1.0) * ratio - s)
end
 
_easeOutBack=function(ratio)
        local invRatio = ratio - 1.0
        local s = 1.70158
        return pow(invRatio, 2.0) * ((s + 1.0) * invRatio - s) + 1.0
end
 
_easeInOutBack=function(ratio)
        if (ratio < 0.5) then 
                return 0.5 * _easeInBack(ratio*2.0)
        else
                return 0.5 * _easeOutBack((ratio-0.5)*2.0) + 0.5
        end
end
 
_easeOutInBack=function(ratio)
        if (ratio < 0.5) then 
                return 0.5 * _easeOutBack(ratio*2.0)
        else
                return 0.5 * _easeInBack((ratio-0.5)*2.0) + 0.5
        end
end