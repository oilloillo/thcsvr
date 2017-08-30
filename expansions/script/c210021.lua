--猿之臂哟！捏碎敌人！
function c210021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c210021.target)
	e1:SetOperation(c210021.activate)
	c:RegisterEffect(e1)
end
function c210021.filter(c)
	return c:IsType(TYPE_SPELL) and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and c:IsFaceup()
end
function c210021.sfilter(c,e,tp)
	return c:IsSetCard(0x710) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c210021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210021.filter,tp,LOCATION_ONFIELD,0,5,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,1,nil)
		and Duel.IsExistingMatchingCard(c210021.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c210021.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetValue(c210021.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c210021.sfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		if tc then 
			if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsType(TYPE_XYZ) then
				Duel.Overlay(tc,e:GetHandler())
			end
		end
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e2:SetOperation(c210021.drop)
	Duel.RegisterEffect(e2,tp)
end
function c210021.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)
end
function c210021.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,210021)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end