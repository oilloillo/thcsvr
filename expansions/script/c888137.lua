 
--七曜-水符「水母公主」
function c888137.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1,888137)
	e4:SetCondition(c888137.rdcon)
	e4:SetOperation(c888137.rdop)
	c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(888137,1))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,888137)
	e5:SetCost(c888137.drcost)
	e5:SetTarget(c888137.drtg)
	e5:SetOperation(c888137.drop)
	c:RegisterEffect(e5)
end
function c888137.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c888137.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1600,REASON_EFFECT)
end
function c888137.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2800) end
	Duel.PayLPCost(tp,2800) 
end
function c888137.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c888137.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end
