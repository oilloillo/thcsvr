--真实之魔女-古户艾莉卡
function c501102.initial_effect(c)
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--announce
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(501102,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c501102.cost)
	e2:SetOperation(c501102.op)
	c:RegisterEffect(e2)
	end
function c501102.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c501102.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(tp,70,71,72)
	Duel.ConfirmDecktop(tp,1)	
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if  (res==0 and tc:IsType(TYPE_MONSTER))
		or (res==1 and tc:IsType(TYPE_SPELL))
		or (res==2 and tc:IsType(TYPE_TRAP)) then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	else
		Duel.DisableShuffleCheck()
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end