 
--七曜-土符「巨石震怒」
function c888155.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Def up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCode(EFFECT_UPDATE_DEFENCE)
	e4:SetValue(500)
	c:RegisterEffect(e4)
	--pae
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(888155,1))
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	e5:SetTarget(c888155.target)
	e5:SetOperation(c888155.operation)
	c:RegisterEffect(e5)
end
function c888155.filter(c)
	return c:IsPosition(POS_DEFENCE)
end
function c888155.dfilter(c)
	return c:IsFaceup()
end
function c888155.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c888155.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c888155.filter,tp,LOCATION_MZONE,0,1,nil) and 
		Duel.IsExistingMatchingCard(c888155.dfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEFENCE)
	local g=Duel.SelectTarget(tp,c888155.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c888155.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not tc:IsPosition(POS_DEFENCE) then return end
	if Duel.ChangePosition(tc,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0 then
		local g=Duel.GetMatchingGroup(c888155.dfilter,tp,0,LOCATION_MZONE,nil)
		local tg=g:GetFirst()
		local c=e:GetHandler()
		while tg do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tg:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tg:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_ATTACK)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tg:RegisterEffect(e3)
			tg=g:GetNext()
		end
	end
end
