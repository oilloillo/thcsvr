 
--最强的剑舞姬-莲‧阿修贝尔
function c40029.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x430),4,2,nil,nil,5)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c40029.atkval)
	c:RegisterEffect(e1)
	--des
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(40029,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c40029.condition)
	e2:SetCost(c40029.cost)
	e2:SetTarget(c40029.target)
	e2:SetOperation(c40029.operation)
	c:RegisterEffect(e2)
	if not c40029.global_check then
		c40029.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(c40029.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c40029.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,40029,RESET_PHASE+PHASE_END,0,1)
end
function c40029.atkval(e,c)
	return c:GetOverlayCount()*200
end
function c40029.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c40029.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetOverlayCount()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,ct,REASON_COST)
	local ctnow=e:GetHandler():GetOverlayCount()
	e:SetLabel(ct-ctnow)
end
function c40029.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetFlagEffect(tp,40029)==0 end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SSET)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(aux.TRUE)
	Duel.RegisterEffect(e1,tp)
end
function c40029.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c40029.op)
	e1:SetReset(RESET_EVENT+0x16c0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c40029.filter(c)
	return c:IsSetCard(0x430) and c:IsAbleToHand()
end
function c40029.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetOverlayCount()
	if ct>0 then Duel.Hint(HINT_CARD,0,40029) end
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	--local g=Duel.SelectMatchingCard(tp,c40029.filter,tp,LOCATION_DECK,0,ct,ct,nil)
	--if g:GetCount()>0 then
	--	Duel.SendtoHand(g,nil,REASON_EFFECT)
	--	Duel.ConfirmCards(1-tp,g)
	--end
	Duel.Draw(tp,ct,REASON_EFFECT)
end
