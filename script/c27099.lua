--『十七条宪法炸弹』
function c27099.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c27099.target)
	e1:SetOperation(c27099.activate)
	c:RegisterEffect(e1)
end
function c27099.cfilter(c)
	return c:IsSetCard(0x194) and (c:IsFaceup() or not c:IsPublic())
end
function c27099.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27099.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c27099.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	local dif=Duel.GetLP(1-tp)-Duel.GetLP(tp)
	if dif>0 then 
		local a,b=math.modf(dif/500)
		if a>16 then a=16 end
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,(a+1)*300)
	else Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300) end
end
function c27099.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c27099.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,300,REASON_EFFECT)
	local dif=Duel.GetLP(1-tp)-Duel.GetLP(tp)
	local a,b=math.modf(dif/500)
	if a>16 then a=16 end
	while a>0 do
		Duel.Damage(1-tp,300,REASON_EFFECT)
		a=a-1
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c27099.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end