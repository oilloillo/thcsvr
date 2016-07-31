 
--Q.E.D.「495年的波纹」
function c22113.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCondition(c22113.condition)
	e1:SetTarget(c22113.sptg)
	e1:SetOperation(c22113.spop)
	c:RegisterEffect(e1)
	if not c22113.global_check then
		c22113.global_check=true
		c22113[0]=false
		c22113[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetOperation(c22113.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c22113.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
c22113.DescSetName = 0xa3
function c22113.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x815) and (tc:IsLocation(LOCATION_GRAVE) or tc:IsLocation(LOCATION_REMOVED)) then
			c22113[tc:GetPreviousControler()]=true
			tc:RegisterFlagEffect(22113,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function c22113.clear(e,tp,eg,ep,ev,re,r,rp)
	c22113[0]=false
	c22113[1]=false
end
function c22113.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END and c22113[tp]
end
function c22113.filter(c,e,tp,tid)
	return c:GetTurnID()==tid and c:IsSetCard(0x815) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:GetFlagEffect(22113)~=0
end
function c22113.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tid=Duel.GetTurnCount()
	if chkc then return (chkc:IsLocation(LOCATION_GRAVE) or chkc:IsLocation(LOCATION_REMOVED)) and chkc:IsControler(tp) and c22113.filter(chkc,e,tp,tid) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c22113.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,tid) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c22113.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,tid)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22113.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local c=e:GetHandler()
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
		local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,c)
		local sg=g:GetFirst()
		while sg do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			sg:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			sg:RegisterEffect(e2)
			sg=g:GetNext()
		end
		local sg2=g2:GetFirst()
		while sg2 do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(0)
			sg2:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENCE_FINAL)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(0)
			sg2:RegisterEffect(e2)
			sg2=g2:GetNext()
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end
