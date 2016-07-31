 
--七曜-日符「皇家烈焰」
--require "expansions/nef/msc"
function c22161.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22161,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c22161.cost)
	e2:SetTarget(c22161.target)
	e2:SetOperation(c22161.operation)
	c:RegisterEffect(e2)
	Msc.RegScMixEffect(c)
end
function c22161.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,22161)==0 end
	Duel.RegisterFlagEffect(tp,22161,RESET_PHASE+PHASE_END,0,1)
end
function c22161.dactfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x811)
end
function c22161.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(1-tp)>3000 and Duel.IsExistingMatchingCard(c22161.dactfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c22161.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
