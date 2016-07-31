--超妖怪弹头✿河城荷取
function c23099.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23099,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c23099.spcost)
	e1:SetTarget(c23099.sptg)
	e1:SetOperation(c23099.spop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23099,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c23099.destg)
	e2:SetOperation(c23099.desop)
	c:RegisterEffect(e2)
end
function c23099.cfilter(c)
	return c:IsFaceup() and c:IsAbleToHandAsCost() and c:IsSetCard(0x817) and c:IsType(TYPE_TUNER)
end
function c23099.filter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c23099.allfilter(c)
	return c:IsFaceup() and ((c:IsAbleToHandAsCost() and c:IsSetCard(0x817) and c:IsType(TYPE_TUNER)) 
		or (c:IsAbleToGraveAsCost() and c:IsType(TYPE_SPELL+TYPE_TRAP)))
end
function c23099.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.IsExistingMatchingCard(c23099.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
	local b=Duel.IsExistingMatchingCard(c23099.filter,tp,LOCATION_ONFIELD,0,3,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return (a) or (b) end
	if a and b then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g1=Duel.SelectMatchingCard(tp,c23099.allfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		if c23099.cfilter(g1:GetFirst()) then
			Duel.SendtoHand(g1,nil,REASON_COST)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g2=Duel.SelectMatchingCard(tp,c23099.filter,tp,LOCATION_ONFIELD,0,2,2,g1:GetFirst())
			g1:Merge(g2)
			Duel.SendtoGrave(g1,REASON_COST)
		end
	elseif a then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,c23099.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c23099.filter,tp,LOCATION_ONFIELD,0,3,3,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c23099.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c23099.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c23099.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc.IsAbleToHand() and chkc:IsControler(1-tp) end
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c23099.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then--e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToEffect(e) and
		local g=Group.CreateGroup()
		g:AddCard(tc)
		g:AddCard(e:GetHandler())
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
