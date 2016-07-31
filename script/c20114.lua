 
--骚符「幽灵絮语」
function c20114.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c20114.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c20114.ctop2)
	c:RegisterEffect(e4)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetTarget(c20114.desreptg)
	c:RegisterEffect(e5)
	--Destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(20114,1))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(2)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCost(c20114.descost)
	e6:SetTarget(c20114.destg)
	e6:SetOperation(c20114.desop)
	c:RegisterEffect(e6)
	--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(20114,2))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCountLimit(1)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCost(c20114.descost)
	e7:SetTarget(c20114.destgg)
	e7:SetOperation(c20114.desopp)
	c:RegisterEffect(e7)
end
function c20114.ctfilter(c,pp)
	return c:GetSummonPlayer()~=pp
end
function c20114.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c20114.ctfilter,1,nil,e:GetHandler():GetControler()) then
		e:GetHandler():AddCounter(0x28b,1)
	end
end
function c20114.ctop2(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c20114.ctfilter,1,nil,e:GetHandler():GetControler()) then
		e:GetHandler():AddCounter(0x28b,2)
	end
end
function c20114.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE)
		and c:IsCanRemoveCounter(tp,0x28b,1,REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(20114,0)) then
		c:RemoveCounter(tp,0x28b,1,REASON_EFFECT)
		return true
	else return false end
end
function c20114.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x28b,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x28b,3,REASON_COST)
end
function c20114.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c20114.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c20114.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20114.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c20114.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c20114.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c20114.destgg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetTurnPlayer()~=tp end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c20114.desopp(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end