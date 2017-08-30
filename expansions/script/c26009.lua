 
--星莲-妖怪行者 云居一轮
function c26009.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26009,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c26009.eqcon)
	e1:SetCost(c26009.cost)
	e1:SetTarget(c26009.eqtg)
	e1:SetOperation(c26009.eqop)
	c:RegisterEffect(e1)
	--synchro limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c26009.synlimit)
	c:RegisterEffect(e2)
end
function c26009.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x251b)
end
function c26009.eqcon(e)
	return not e:GetHandler():GetEquipGroup():IsExists(c26009.eqfilter,1,nil)
end
function c26009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,26009)==0 end
	Duel.RegisterFlagEffect(tp,26009,RESET_PHASE+PHASE_END,0,1)
end
function c26009.filter(c)
	return c:IsSetCard(0x251b) and c:IsType(TYPE_MONSTER) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c26009.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c26009.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c26009.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c26009.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c,true) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c26009.eqlimit)
		tc:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SKIP_BP)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetLabel(Duel.GetTurnCount())
	e2:SetCondition(c26009.skipcon)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	Duel.RegisterEffect(e2,tp)
end
function c26009.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c26009.eqlimit(e,c)
	return e:GetOwner()==c
end
function c26009.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x251)
end
