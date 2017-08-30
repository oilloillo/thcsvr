 
--咒符「稻草人形神风」
function c20159.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c20159.cost)
	e1:SetTarget(c20159.target)
	e1:SetOperation(c20159.activate)
	c:RegisterEffect(e1)
end
function c20159.cfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x186) and c:IsRace(RACE_MACHINE)
end
function c20159.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local gc=Duel.GetMatchingGroupCount(c20159.cfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return gc>2 end
	local g=Duel.SelectMatchingCard(tp,c20159.cfilter,tp,LOCATION_GRAVE,0,3,58,nil)
	e:SetLabel(g:GetCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c20159.filter(c,atk)
	return c:IsAbleToHand() and c:GetAttack()<=atk and c:IsFaceup()
end
function c20159.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c20159.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c20159.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.BreakEffect()
	local atk=e:GetLabel()*1000
	local g=Duel.GetMatchingGroup(c20159.filter,tp,0,LOCATION_MZONE,nil,atk)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c20159.aclimit(e,re,tp)
	return re:GetHandler():IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE)
end
