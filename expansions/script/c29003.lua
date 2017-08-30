 --淡水的人鱼✿若鹭姬
function c29003.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29003,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c29003.cost)
	e1:SetTarget(c29003.target)
	e1:SetOperation(c29003.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29003,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(c29003.spcon)
	e2:SetTarget(c29003.sptg)
	e2:SetOperation(c29003.operation)
	c:RegisterEffect(e2)
end
function c29003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,29003)==0 and e:GetHandler():GetAttack()>0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(0)
	e:GetHandler():RegisterEffect(e1)
	Duel.RegisterFlagEffect(tp,29003,RESET_PHASE+PHASE_END,0,1)
end
function c29003.filter(c)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt and mt.DescSetName==0x826 and c:IsAbleToHand()
end
function c29003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29003.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29003.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29003.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c29003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c29003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,290030)==0 and Duel.IsExistingMatchingCard(c29003.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.RegisterFlagEffect(tp,290030,RESET_PHASE+PHASE_END,0,1)
end
