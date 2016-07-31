 
--しろかみ 莉亚娜·芬布鲁
function c60029.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60029,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCondition(c60029.condition)
	e1:SetTarget(c60029.target)
	e1:SetOperation(c60029.operation)
	c:RegisterEffect(e1)
	--synlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetValue(c60029.synlimit)
	c:RegisterEffect(e3)
end
function c60029.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c60029.filter(c)
	return c:IsSetCard(0x191) and c:IsAbleToHand()
end
function c60029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60029.filter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,60029)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.RegisterFlagEffect(tp,60029,RESET_PHASE+PHASE_END,0,1)
end
function c60029.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60029.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c60029.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x191)
end
