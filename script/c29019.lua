 
--小人的末裔✿少名针妙丸
function c29019.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29019,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	--e1:SetCountLimit(1)
	e1:SetCost(c29019.cost)
	e1:SetTarget(c29019.target)
	e1:SetOperation(c29019.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29019,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetCountLimit(1)
	e2:SetCost(c29019.cost)
	e2:SetTarget(c29019.sptg)
	e2:SetOperation(c29019.sbop)
	c:RegisterEffect(e2)
end

c29019.DescSetName=0x826

function c29019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=e:GetHandler():GetAttack()
	if chk==0 then return atk>0 and Duel.GetFlagEffect(tp,29019)==0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(-atk)
	e:GetHandler():RegisterEffect(e1)
	Duel.RegisterFlagEffect(tp,29019,RESET_PHASE+PHASE_END,0,1)
end
function c29019.filter(c)
	return (c:IsSetCard(0x253) or c:IsSetCard(0x259)) and c:IsAbleToHand()
end
function c29019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(29019)==0 and Duel.IsExistingMatchingCard(c29019.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	e:GetHandler():RegisterFlagEffect(29019,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c29019.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29019.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c29019.hfilter(c)
	return c:GetOriginalCode()==(29030) and c:IsAbleToHand()
end
function c29019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(29019)==0 and Duel.IsExistingMatchingCard(c29019.hfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	e:GetHandler():RegisterFlagEffect(29019,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c29019.sbop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29019.hfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
