 
--红魔 图书馆的女仆 小恶魔
function c22202.initial_effect(c)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22202,0))
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(3)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c22202.target)
	e2:SetOperation(c22202.operation)
	c:RegisterEffect(e2)
end
function c22202.dfilter(c)
	return c:IsDiscardable()
end
function c22202.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22202.dfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c22202.filter(c)
	return (c:IsCode(22033) or c:IsCode(22064)) and c:IsAbleToHand()
end
function c22202.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.DiscardHand(tp,c22202.dfilter,1,1,REASON_EFFECT+REASON_DISCARD,nil)
	local g=Duel.GetOperatedGroup()
	if ct>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
		e1:SetValue(300)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENCE)
		c:RegisterEffect(e2)
		local tg=g:GetFirst()
		if (tg:IsSetCard(0x813) or tg:GetOriginalCode()==(22100) or tg:GetOriginalCode()==(22117))
			and Duel.SelectYesNo(tp,aux.Stringid(22202,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,c22202.filter,tp,LOCATION_DECK,0,1,1,nil)
			if sg:GetCount()>0 then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		elseif tg:IsSetCard(0x177) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
