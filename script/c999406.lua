--禁忌『被禁止的游戏』
function c999406.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,999406+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c999406.activate)
	c:RegisterEffect(e1)
	--battle
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c999406.cost)
	e2:SetCondition(c999406.con)
	e2:SetTarget(c999406.tg)
	e2:SetOperation(c999406.op)
	c:RegisterEffect(e2)
end

c999406.DescSetName = 0xa3

function c999406.tgfilter(c)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt and mt.DescSetName == 0xa3 and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToGrave()
end

function c999406.thfilter(c)
	return c:IsSetCard(0x815) and c:IsAbleToHand()
end

function c999406.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(c999406.tgfilter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c999406.thfilter,tp,LOCATION_DECK,0,nil)
	local flag1=g1:GetCount()>1
	local flag2=g1:GetCount()>0 and g2:GetCount()>0
	if (flag1 or flag2) and Duel.SelectYesNo(tp,aux.Stringid(999406,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g1:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
		g1:RemoveCard(sg:GetFirst())
		--
		Duel.BreakEffect()
		--
		local g3=Group.CreateGroup()
		if flag1 and g1 then g3:Merge(g1) end
		if flag2 and g2 then g3:Merge(g2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local sg=g3:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc:IsType(TYPE_MONSTER) then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		else
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end

function c999406.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end

function c999406.costfilter(c)
	return c:IsCode(999406) and c:IsAbleToRemoveAsCost()
end

function c999406.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c999406.costfilter, tp, LOCATION_GRAVE, 0, nil)
	local rep = Duel.GetFlagEffect(tp, 999410)
	local num = 3 - rep
	if num < 1 then num = 1 end
	if chk==0 then return g:GetCount()>=num end
	local rg=g:RandomSelect(tp,num)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.ResetFlagEffect(tp, 999410)
end

function c999406.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,0,LOCATION_MZONE,1,nil,TYPE_MONSTER) and
		Duel.IsExistingTarget(c999406.thfilter,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g1=Duel.SelectTarget(tp,Card.IsType,tp,0,LOCATION_MZONE,1,1,nil,TYPE_MONSTER)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g2=Duel.SelectTarget(tp,c999406.thfilter,tp,LOCATION_MZONE,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,0,g1,g1:GetCount(),0,0)
end

function c999406.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=2 then return end
	local fc=g:GetFirst()
	local sc=g:GetNext()
	if not (fc:IsLocation(LOCATION_MZONE) and sc:IsLocation(LOCATION_MZONE)) then return end
	if not fc:IsPosition(POS_FACEUP_ATTACK) then
		Duel.ChangePosition(fc,POS_FACEUP_ATTACK)
	end
	if not sc:IsPosition(POS_FACEUP_ATTACK) then
		Duel.ChangePosition(sc,POS_FACEUP_ATTACK)
	end
	if not (fc:IsLocation(LOCATION_MZONE) and sc:IsLocation(LOCATION_MZONE)) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetTargetRange(1,1)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	Duel.CalculateDamage(sc,fc)
end