--龙脉剥换的神灵✿物部布都
--require "expansions/nef/nef"
function c27076.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	local argTable = {TYPE_RITUAL,0x208}
	Nef.EnablePendulumAttributeSP(c,5,c27076.pendFilter,argTable,false,"GodSprite")
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27076,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c27076.cost)
	e2:SetTarget(c27076.target)
	e2:SetOperation(c27076.operation)
	c:RegisterEffect(e2)
	--hand des
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27076,1))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,27076)
	e3:SetCondition(c27076.rcon)
	e3:SetTarget(c27076.rtg)
	e3:SetOperation(c27076.rop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(27076,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,270760)
	e4:SetCondition(c27076.pcon)
	e4:SetTarget(c27076.ptg)
	e4:SetOperation(c27076.pop)
	c:RegisterEffect(e4)
end
function c27076.pendFilter(c, ctype, setname)
	return c:IsType(ctype) and c:IsSetCard(setname)
end
function c27076.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c27076.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x912) and not c:IsCode(27076)
end
function c27076.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27076.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c27076.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c27076.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(sg:GetFirst(),0)
		Duel.ConfirmDecktop(tp,1)
	end
end
function c27076.rcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c27076.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,400)
end
function c27076.rop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		Duel.Recover(tp,400,REASON_EFFECT)
	end
end
function c27076.pcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c27076.pfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c27076.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27076.pfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c27076.pfilter,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,1,0,0)
end
function c27076.pop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c27076.pfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		else Duel.SendtoHand(tg,nil,REASON_EFFECT) end
	end
end
