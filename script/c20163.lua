 
--告春精✿莉莉霍瓦特
function c20163.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20163,0))
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c20163.rectg)
	e1:SetOperation(c20163.recop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20163,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c20163.condition)
	e2:SetCost(c20163.cost)
	e2:SetTarget(c20163.target)
	e2:SetOperation(c20163.operation)
	c:RegisterEffect(e2)
end
function c20163.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,0xe)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c20163.recop(e,tp,eg,ep,ev,re,r,rp)
	local rt=Duel.GetFieldGroupCount(tp,0,0xe)*300
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,rt,REASON_EFFECT)
end
function c20163.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>=10000
end
function c20163.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,20163)==0 end
	Duel.PayLPCost(tp,400)
	Duel.RegisterFlagEffect(tp,20163,RESET_PHASE+PHASE_END,0,1)
end
function c20163.filter(c)
	return c:IsSetCard(0x123) and c:IsAbleToHand()
end
function c20163.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20163.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c20163.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c20163.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
