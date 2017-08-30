--港符『幽灵船之港』
function c26138.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,26138)
	e2:SetCondition(c26138.spcon)
	e2:SetTarget(c26138.sptg)
	e2:SetOperation(c26138.spop)
	c:RegisterEffect(e2)
	--Special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26138,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,261380)
	e4:SetTarget(c26138.tg)
	e4:SetOperation(c26138.op)
	c:RegisterEffect(e4)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26138,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,261380)
	e3:SetCost(c26138.cost)
	e3:SetTarget(c26138.target)
	e3:SetOperation(c26138.operation)
	c:RegisterEffect(e3)
end
function c26138.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_SZONE
end
function c26138.spfilter(c,e,tp)
	return c:IsSetCard(0x251d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26138.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26138.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c26138.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c26138.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c26138.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c26138.spfilter2(c,e,tp)
	local flag1 = c:IsLocation(LOCATION_HAND)
	local flag2 = c:IsLocation(LOCATION_SZONE) and (c:GetSequence()==6 or c:GetSequence()==7) and c:IsFaceup()
	local flag3 = c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()
	return c:IsSetCard(0x251d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (flag1 or flag2 or flag3)
end
function c26138.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local lpz=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rpz=Duel.GetFieldCard(tp,LOCATION_SZONE,7)

	if chk==0 then return e:GetHandler():GetFlagEffect(26138)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26138.spfilter2,tp,0x4a,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	e:GetHandler():RegisterFlagEffect(26138,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c26138.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c26138.spfilter2,tp,0x4a,0,1,1,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c26138.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,aux.TRUE,1,e:GetHandler()) end
	local sg=Duel.SelectReleaseGroupEx(tp,aux.TRUE,1,1,e:GetHandler())
	Duel.Release(sg,REASON_COST)
end
function c26138.filter(c)
	return c:IsSetCard(0x381) and c:IsAbleToHand()
end
function c26138.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(26138)==0 and Duel.IsExistingMatchingCard(c26138.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	e:GetHandler():RegisterFlagEffect(26138,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c26138.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26138.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
