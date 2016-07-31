--5pb.
function c70064.initial_effect(c)
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70064,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c70064.thcon)
	e1:SetTarget(c70064.thtg)
	e1:SetOperation(c70064.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
end
function c70064.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ)
		and re:GetHandler():IsAttribute(ATTRIBUTE_WIND)
end
function c70064.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_XYZ)
end
function c70064.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c70064.xyzfilter(c)
	return c:IsAbleToChangeControler() and not c:IsType(TYPE_TOKEN)
end
function c70064.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	local c=e:GetHandler():GetOverlayTarget()
	if tc:IsSetCard(0x149) and tc:IsType(TYPE_MONSTER) or tc:IsCode(70064) then
		if Duel.IsExistingMatchingCard(c70064.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) then
			--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local dg=Duel.SelectMatchingCard(tp,c70064.xyzfilter,tp,0,LOCATION_MZONE,1,1,nil)
			local g=Duel.SelectMatchingCard(tp,c70064.filter,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.Overlay(g:GetFirst(),dg)
		end
	end
	Duel.ShuffleHand(tp)
end
