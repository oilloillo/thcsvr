 
--永夜返 -世间开明-
function c21120.initial_effect(c)
	c:SetUniqueOnField(1,0,21120)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c21120.target)
	e1:SetOperation(c21120.activate)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x256))
	e2:SetValue(c21120.val)
	c:RegisterEffect(e2)
	--activate in set turn
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetCondition(c21120.con)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x257))
	c:RegisterEffect(e3)
end
function c21120.filter(c)
	return c:IsSetCard(0x257) and c:IsFaceup() and c:IsType(TYPE_TRAP)
end
function c21120.afilter(c)
	return c:IsSetCard(0x257) and c:IsType(TYPE_TRAP)
end
function c21120.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c21120.filter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c21120.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c21120.filter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c21120.condition)
	e1:SetOperation(c21120.operation)
	e:GetHandler():RegisterEffect(e1)
end
function c21120.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(21120)==0
end
function c21120.val(e,c)
	return Duel.GetMatchingGroupCount(c21120.afilter,c:GetControler(),LOCATION_GRAVE,0,nil)*200
end
function c21120.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP) and re:GetHandler():GetTurnID()==Duel.GetTurnCount() and re:GetHandler():IsSetCard(0x257)
	and re:GetHandler():GetFlagEffect(21101)==0
end
function c21120.operation(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(21120,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
