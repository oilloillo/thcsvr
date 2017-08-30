--康帕
function c70061.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70061,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c70061.sumcon)
	e1:SetTarget(c70061.target)
	e1:SetOperation(c70061.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
end
function c70061.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c70061.filter(c)
	return (c:IsCode(70001) or c:IsCode(70030)) and c:IsAbleToHand()
end
function c70061.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c70061.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c70061.filter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(70061,1)) then
		sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
