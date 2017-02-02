--幼小的稚气恶魔✿伊莉丝
function c11029.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11029,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c11029.cost)
	e1:SetTarget(c11029.destg)
	e1:SetOperation(c11029.desop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11029,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,11029)
	e2:SetCost(c11029.thcost)
	e2:SetTarget(c11029.thtg)
	e2:SetOperation(c11029.thop)
	c:RegisterEffect(e2)
end
function c11029.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11029.filter(c)
	return (c:IsLevelBelow(9) or c:IsRankBelow(9) or c:IsType(TYPE_SPELL+TYPE_TRAP)) and c:IsDestructable()
end
function c11029.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c11029.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11029.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c11029.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c11029.mofuckfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c11029.desop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			local tpa=tc:GetControler()
			local thg=Duel.GetMatchingGroup(c11029.mofuckfilter,tpa,LOCATION_GRAVE,0,nil)
			if thg:GetCount()>0 and Duel.SelectYesNo(tpa,aux.Stringid(11029,2)) then
				local sg=thg:Select(tpa,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
			end
		end
	end
end
function c11029.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and e:GetHandler():GetOverlayCount()==0 end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c11029.thfilter(c)
	return c:IsSetCard(0x208) and c:IsAbleToHand() and c:GetLevel()==4
end
function c11029.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c11029.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11029.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c11029.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c11029.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
