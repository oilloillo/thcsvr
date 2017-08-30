--天候-雪
function c200108.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_HANDES)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)--+EFFECT_FLAG_BOTH_SIDE
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c200108.target)
	e2:SetOperation(c200108.op)
	c:RegisterEffect(e2)
end
function c200108.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return --tp==Duel.GetTurnPlayer() and 
	ep~=tp and bit.band(r,REASON_EFFECT)==0 and Duel.IsPlayerCanDiscardDeck(1-tp,3) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(200108,0))
	e:SetLabel(Duel.SelectOption(tp,70,71,72))
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,3)
end
function c200108.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsOnField() then return end
	Duel.ConfirmDecktop(1-tp,3)
	local g=Duel.GetDecktopGroup(1-tp,3)
	if g:GetCount()==3 then
		local t=0
		local opt=e:GetLabel()
		if opt==0 then t=TYPE_MONSTER
		else if opt==1 then t=TYPE_SPELL
			else t=TYPE_TRAP end
		end
		local gc=g:FilterCount(Card.IsType,nil,t)
		Duel.DiscardDeck(1-tp,3,REASON_EFFECT)
		Duel.Hint(HINT_NUMBER,tp,gc)
		if gc>=2 then 
			local hg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0,nil)
			local shg=hg:RandomSelect(1-tp,1)
			Duel.SendtoGrave(shg,REASON_DISCARD+REASON_EFFECT)
		end
	end
end
