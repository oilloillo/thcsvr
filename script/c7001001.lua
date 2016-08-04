--鸟空✿
function c7001001.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7001001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,7001001)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c7001001.con)
	e1:SetTarget(c7001001.sptg)
	e1:SetOperation(c7001001.spop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7001001,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,7001001)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c7001001.con)
	e2:SetTarget(c7001001.thtg)
	e2:SetOperation(c7001001.thop)
	c:RegisterEffect(e2)
end
function c7001001.cfilter(c,tp)
	return  c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP)
		and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp)) and not c:IsType(TYPE_EFFECT)
end
function c7001001.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c7001001.cfilter,1,nil,tp)
end
function c7001001.spfilter(c,e,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENCE)
end
function c7001001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=eg:FilterCount(c7001001.spfilter,nil,e,tp)
		return ct>0 and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
	end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(c7001001.spfilter,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c7001001.spfilter2(c,e,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENCE) and c:IsRelateToEffect(e)
end
function c7001001.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local sg=eg:Filter(c7001001.spfilter2,nil,e,tp)
	if ft<sg:GetCount() then return end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
end
function c7001001.thfilter(c,e,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD)  and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) 
end
function c7001001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=eg:FilterCount(c7001001.thfilter,nil,e,tp)
		return ct>0 --and not Duel.IsPlayerAffectedByEffect(tp,21154)
	end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(c7001001.thfilter,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c7001001.thfilter2(c,e,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD)  and c:IsAbleToHand() and c:IsRelateToEffect(e)
end
function c7001001.thop(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c7001001.thfilter2,nil,e,tp)
	if sg:GetCount()<1 then return end
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
