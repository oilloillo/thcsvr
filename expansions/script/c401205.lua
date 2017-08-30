--纯灰色的栖舰港口
function c401205.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(401205,0))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,401205)
	e4:SetTarget(c401205.target1)
	e4:SetOperation(c401205.operation1)
	c:RegisterEffect(e4)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(401205,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,401205)
	e2:SetCost(c401205.spcost)
	e2:SetTarget(c401205.sptg)
	e2:SetOperation(c401205.spop)
	c:RegisterEffect(e2)
	--self destroy
     local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(401205,2))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetProperty(EFFECT_FLAG_REPEAT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c401205.tdcon)
	e5:SetTarget(c401205.tdtg)
	e5:SetOperation(c401205.tdop)
	c:RegisterEffect(e5)

end

function c401205.filter(c)
	return c:IsFacedown() and c:IsSetCard(0x911)
end
function c401205.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and ce2.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c401205.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(401205,2))
	local g=Duel.SelectTarget(tp,c401205.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c401205.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	end
end
function c401205.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0x911)
end
function c401205.tdcon(e,tp,eg,ep,ev,re,r,rp)
      return not Duel.IsExistingMatchingCard(c401205.afilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c401205.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c401205.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
	
function c401205.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end

function c401205.filter2(c)
	return c:IsSetCard(0x911) and c:IsAbleToHand()
end
function c401205.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c401205.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c401205.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c401205.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
end
end