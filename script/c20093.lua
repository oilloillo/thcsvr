 
--反魂蝶
function c20093.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20093.target)
	e1:SetOperation(c20093.activate)
	c:RegisterEffect(e1)
end
function c20093.filter(c,e,tp,atk)
	return c:IsSetCard(0x208) and c:IsType(TYPE_SPIRIT) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
		and c:GetAttack()<=atk
end
function c20093.costfilter(c)
	return c:IsSetCard(0x684) and c:IsAbleToRemoveAsCost()
end
function c20093.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c20093.costfilter,tp,LOCATION_GRAVE,0,nil)
	local atk=ct*1200
	if chk==0 then return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20093.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp,atk) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c20093.costfilter,tp,LOCATION_GRAVE,0,1,ct,nil)
	local lct=g:GetCount()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(lct)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE+LOCATION_HAND)
end
function c20093.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local atk=e:GetLabel()*1200
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20093.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp,atk)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
end
