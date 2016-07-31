 
--七曜-火符「火神之光上级」
function c22136.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c22136.con)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22136,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c22136.acttg)
	e2:SetOperation(c22136.actop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_DECK)
	e3:SetCondition(c22136.actcon)
	c:RegisterEffect(e3)
	--damage up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(c22136.rdcon)
	e4:SetOperation(c22136.rdop)
	c:RegisterEffect(e4)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_DESTROYED)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c22136.dmcon)
	e5:SetTarget(c22136.dmtg)
	e5:SetOperation(c22136.dmop)
	c:RegisterEffect(e5)
end
function c22136.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(22136)==1
end
function c22136.actfilter(c)
	return c:IsSetCard(0x178) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function c22136.exfilter(c)
	return c:IsCode(22200) and c:GetFlagEffect(2220000)>0
end
function c22136.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22136.actfilter,tp,LOCATION_SZONE,0,2,nil) or
		(Duel.IsExistingMatchingCard(c22136.exfilter,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(c22136.actfilter,tp,LOCATION_SZONE,0,1,nil)) end
	e:GetHandler():RegisterFlagEffect(22136,RESET_EVENT+0x1fe0000,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c22136.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=0
	if Duel.IsExistingMatchingCard(c22136.exfilter,tp,LOCATION_SZONE,0,1,nil) 
		then ct=1
	else ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22136.actfilter,tp,LOCATION_SZONE,0,ct,ct,nil)
		if Duel.SendtoGrave(g,REASON_MATERIAL)~=0 then
		if not e:GetHandler():GetActivateEffect():IsActivatable(tp) then return end
			Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CHAIN_SOLVED,e:GetHandler():GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c22136.dactfilter(c)
	return c:IsFaceup() and c:IsCode(22017)
end
function c22136.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22136.dactfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22136.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c22136.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,700,REASON_BATTLE)
end
function c22136.filter(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:GetPreviousControler()~=tp
end
function c22136.dmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22136.filter,1,nil,tp)
end
function c22136.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(700)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,700)
end
function c22136.dmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
