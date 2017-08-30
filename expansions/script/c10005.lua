 
--普通的魔法使
function c10005.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(c10005.xyzfilter),5,2)
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10005,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c10005.condition)
	e1:SetCost(c10005.cost)
	e1:SetOperation(c10005.operation)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c10005.val)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10005,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c10005.descost)
	e3:SetTarget(c10005.destg)
	e3:SetOperation(c10005.desop)
	c:RegisterEffect(e3)
end
function c10005.xyzfilter(c)
	return c:IsSetCard(0x208) and c:IsRace(RACE_SPELLCASTER)
end
function c10005.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c10005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10005.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ShuffleHand(1-tp)
end
function c10005.val(e,c)
	return Duel.GetMatchingGroupCount(c10005.filter,c:GetControler(),LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,nil)*100
end
function c10005.filter(c)
	return c:IsRace(RACE_SPELLCASTER) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c10005.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c10005.dfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c10005.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(c10005.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10005.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c10005.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10005.dfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c10005.dfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c10005.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10005.dfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end