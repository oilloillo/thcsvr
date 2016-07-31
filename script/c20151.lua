 
--西藏人形✿
function c20151.initial_effect(c)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20151,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c20151.cost)
	e1:SetTarget(c20151.target)
	e1:SetOperation(c20151.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
	--cannot be battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetTarget(c20151.tg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c20151.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,20151)==0 and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,20151,RESET_PHASE+PHASE_END,0,1)
end
function c20151.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x186) and c:IsType(TYPE_MONSTER)
end
function c20151.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c20151.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20151.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c20151.filter,tp,LOCATION_REMOVED,0,1,6,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c20151.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(20151,1)) then
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
		else
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
	end
end
function c20151.tg(e,c)
	return c:IsSetCard(0x300) and c:IsLevelAbove(5)
end
