 
--凑符「魅影船港」
function c26027.initial_effect(c)
	c:SetUniqueOnField(1,1,26027)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26027,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c26027.drtg)
	e2:SetOperation(c26027.drop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26027,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c26027.cost)
	e3:SetTarget(c26027.target)
	e3:SetOperation(c26027.operation)
	c:RegisterEffect(e3)
	--Special summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c26027.spcon)
	e5:SetTarget(c26027.sptg)
	e5:SetOperation(c26027.spop)
	c:RegisterEffect(e5)
end
function c26027.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(26027)==0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	e:GetHandler():RegisterFlagEffect(26027,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c26027.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	if g and g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c26027.cfilter(c)
	return c:IsSetCard(0x381) or c:IsCode(5265750) or c:IsCode(33347467) or c:IsCode(33911264) or c:IsCode(51534754)
end
function c26027.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c26027.cfilter,1,e:GetHandler()) end
	local sg=Duel.SelectReleaseGroup(tp,c26027.cfilter,1,1,e:GetHandler())
	Duel.Release(sg,REASON_COST)
end
function c26027.filter(c)
	return (c:IsSetCard(0x381) or c:IsCode(5265750) or c:IsCode(33347467) or c:IsCode(33911264) or c:IsCode(51534754)) and c:IsAbleToHand()
end
function c26027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(26027)==0 and Duel.IsExistingMatchingCard(c26027.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	e:GetHandler():RegisterFlagEffect(26027,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c26027.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26027.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c26027.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c26027.spfilter(c,e,tp)
	return c:IsCode(26005) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c26027.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c26027.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c26027.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c26027.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c26027.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
