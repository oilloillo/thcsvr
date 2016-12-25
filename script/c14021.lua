--欢迎回来 梦幻馆
function c14021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c14021.target)
	e1:SetOperation(c14021.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14021,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,14021)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c14021.thcost)
	e2:SetTarget(c14021.thtg)
	e2:SetOperation(c14021.thop)
	c:RegisterEffect(e2)
end
function c14021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c14021.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14021,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCondition(c14021.otcon)
	e1:SetTarget(c14021.ottg)
	e1:SetOperation(c14021.otop)
	--e1:SetCountLimit(1)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,14021,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
end
function c14021.rmfilter(c)
	return c:IsSetCard(0x138) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c14021.otcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c14021.rmfilter,tp,LOCATION_DECK,0,1,nil)
end
function c14021.ottg(e,c)
	local mi,ma=c:GetTributeRequirement()
	return mi>=1
end
function c14021.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mi,ma=c:GetTributeRequirement()
	Duel.Hint(HINT_CARD,0,14021)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c14021.rmfilter,tp,LOCATION_DECK,0,mi,ma,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.ResetFlagEffect(tp,14021)
end
function c14021.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c14021.thfilter(c)
	return c:IsSetCard(0x138) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and (c:IsFaceup() or c:IsLocation(LOCATION_DECK))
end
function c14021.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c14021.thfilter,tp,0x21,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x21)
end
function c14021.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c14021.thfilter,tp,0x21,0,nil)
	local gc=g:GetClassCount(Card.GetCode)
	if gc>2 then

		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())

		local g2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
		g1:Merge(g2)

		local g3=g:Select(tp,1,1,nil)
		g1:Merge(g3)

		Duel.ConfirmCards(1-tp,g1)
		local tg=g1:RandomSelect(1-tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
		g1:RemoveCard(tg:GetFirst())
		Duel.SendtoGrave(g1,REASON_EFFECT)
	end
end
