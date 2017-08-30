--重生之草莓十字
function c13053.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c13053.target)
	e1:SetOperation(c13053.activate)
	c:RegisterEffect(e1)
	--sol
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetTarget(c13053.thtg)
	e2:SetOperation(c13053.thop)
	c:RegisterEffect(e2)
end
function c13053.filter(c,e,tp)
	return c:IsSetCard(0x13d) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c13053.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()==tp and c13053.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c13053.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c13053.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c13053.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetTargetRange(1,0)
		e3:SetValue(c13053.aclimit)
			e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function c13053.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) and not re:GetHandler():IsSetCard(0x13e)
end
function c13053.tgfilter(c)
	return c:IsDestructable() and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0 and c:GetPreviousLocation()==LOCATION_GRAVE
end
function c13053.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(c13053.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0)
	end
end
function c13053.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c13053.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		sg=g:RandomSelect(tp,1)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
