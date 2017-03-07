--天魔界✿梦子
function c15053.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,2)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(15053,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c15053.imcost)
	e1:SetTarget(c15053.imtg)
	e1:SetOperation(c15053.imop)
	c:RegisterEffect(e1)
	--addown
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(15053,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c15053.cost)
	e2:SetTarget(c15053.target)
	e2:SetOperation(c15053.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c15053.imcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fa=Duel.GetFlagEffect(tp,15000)
	local fb=Duel.GetFlagEffect(tp,150000)
	local fc=fa-fb
	if chk==0 then return fc<3 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.RegisterFlagEffect(tp,15000,RESET_PHASE+PHASE_END,0,1)
end
function c15053.imfilter(c)
	return c:IsFaceup()
end
function c15053.imtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c15053.imfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c15053.imfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c15053.imfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c15053.imop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetRange(LOCATION_ONFIELD)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(c15053.efilter)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		Duel.RegisterFlagEffect(tp,150000,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(tp,150000,RESET_PHASE+PHASE_END,0,1)
	end
end
function c15053.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActiveType(TYPE_SPELL)
end
function c15053.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fa=Duel.GetFlagEffect(tp,15000)
	local fb=Duel.GetFlagEffect(tp,150000)
	local fc=fa-fb
	if chk==0 then return fc<3 end
	Duel.RegisterFlagEffect(tp,15000,RESET_PHASE+PHASE_END,0,1)
end
function c15053.filter(c,d)
	return c~=d and c:IsFaceup() and (c:GetAttack()>0 or c:GetDefense()>0)
end
function c15053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=e:GetHandler()
	if chk==0 then return eg:IsExists(c15053.filter,1,nil,d) end
end
function c15053.operation(e,tp,eg,ep,ev,re,r,rp)
	local d=e:GetHandler()
	local g=Duel.GetMatchingGroup(c15053.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,d)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(d)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-700)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end
