--永远的春梦✿哆来咪·苏伊特
function c31024.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x208),1)
	c:EnableReviveLimit()
	--search set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31024,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c31024.setcon)
	e1:SetTarget(c31024.settg)
	e1:SetOperation(c31024.setop)
	c:RegisterEffect(e1)
	--spell set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(31024,1))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCondition(c31024.condition)
	e3:SetTarget(c31024.stg)
	e3:SetOperation(c31024.sop)
	c:RegisterEffect(e3)
end
function c31024.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c31024.filter(c)
	return c:IsSetCard(0x279) and c:IsSSetable() and c:IsAbleToGrave()
end
function c31024.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c31024.filter,tp,LOCATION_DECK,0,3,nil) end
end
function c31024.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c31024.filter,tp,LOCATION_DECK,0,3,3,nil)
	if g:GetCount()>2 then
		local sg=g:RandomSelect(tp,1)
		local tc=sg:GetFirst()
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		g:RemoveCard(tc)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c31024.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsLocation(LOCATION_DECK) and c:IsReason(REASON_BATTLE)
end
function c31024.sfilter(c)
	return c:IsSetCard(0x279) and c:IsSSetable()
end
function c31024.stg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c31024.sfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c31024.sfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c31024.sfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
end
function c31024.sop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SSet(tp,tc) then
		Duel.ConfirmCards(1-tp,tc)
    end
end
