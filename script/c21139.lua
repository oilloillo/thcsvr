--木菟咆哮 米斯蒂娅✿萝蕾拉
function c21139.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetDescription(aux.Stringid(21139,0))
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCountLimit(1)
	e2:SetCondition(c21139.adcon)
	e2:SetTarget(c21139.adtg)
	e2:SetOperation(c21139.adop)
	c:RegisterEffect(e2)
	--sp
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetDescription(aux.Stringid(21139,1))
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c21139.sptg)
	e3:SetOperation(c21139.spop)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetDescription(aux.Stringid(21139,2))
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCountLimit(1,21139)
	e4:SetCondition(c21139.scrcon)
	e4:SetTarget(c21139.sctg)
	e4:SetOperation(c21139.scop)
	c:RegisterEffect(e4)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(21139,3))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_START)
	e6:SetTarget(c21139.destg)
	e6:SetOperation(c21139.desop)
	c:RegisterEffect(e6)
end
function c21139.adcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c21139.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c21139.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c21139.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21139.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c21139.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c21139.adop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetAttack()/2)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENCE_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetDefence()/2)
		tc:RegisterEffect(e1)
	end
end
function c21139.filter2(c,e,tp)
	return c:IsSetCard(0x522) and c:IsReason(REASON_RELEASE) and c:GetTurnID()==Duel.GetTurnCount() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c21139.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c21139.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil,e,tp) end
end
function c21139.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c21139.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,ft,nil,e,tp)
		if g:GetCount()>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)	end
	end
end
function c21139.scrcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_RELEASE)
end
function c21139.filter3(c)
	return c:IsSetCard(0x527) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c21139.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21139.filter3,tp,LOCATION_DECK,0,1,nil) end
end
function c21139.scop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c21139.filter3,tp,LOCATION_DECK,0,1,nil) then
		local g=Duel.SelectMatchingCard(tp,c21139.filter3,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)	
	end
end
function c21139.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then return tc and tc:IsFaceup() and (tc:GetRace()==RACE_BEAST or tc:GetRace()==RACE_BEASTWARRIOR) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1200)
end
function c21139.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	if tc:IsRelateToBattle() then
		if Duel.Destroy(tc,REASON_EFFECT)>0 then Duel.Damage(1-tp,1200,REASON_EFFECT) end
	end
end