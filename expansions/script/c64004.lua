--崩坏 雷电芽衣
function c64004.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	--destroy1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64004,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c64004.cost1)
	e1:SetTarget(c64004.target1)
	e1:SetOperation(c64004.operation1)
	c:RegisterEffect(e1)
	--cna
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64004,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c64004.tg2)
	e2:SetOperation(c64004.op2)
	c:RegisterEffect(e2)
end
function c64004.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c64004.filter1(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c64004.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c64004.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1200)
end
function c64004.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c64004.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local sg=g:RandomSelect(tp,1)
	Duel.HintSelection(sg)
	if Duel.Destroy(sg,REASON_EFFECT)>0 then
		Duel.Damage(1-tp,1200,REASON_EFFECT)
	end
end
function c64004.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c64004.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)	
	end
end
