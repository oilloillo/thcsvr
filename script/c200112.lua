--天候-晴岚
function c200112.initial_effect(c)	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(200112,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,200112)
	e2:SetLabelObject(e1)
	e2:SetTarget(c200112.tg)
	e2:SetOperation(c200112.op)
	c:RegisterEffect(e2)
end
function c200112.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	local tc2=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	if chk==0 then return tc and tc:IsAbleToHand() and tc2 and tc2:IsAbleToHand() end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(200112,1))
	e:SetLabel(Duel.SelectOption(tp,70,71,72))
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(200112,1))
	e:GetLabelObject():SetLabel(Duel.SelectOption(1-tp,70,71,72))
end
function c200112.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	local tc2=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	if e:GetHandler():IsOnField() and tc and tc:IsAbleToHand() and tc2 and tc2:IsAbleToHand() then
	local right1=0
	local right2=0
	local t=0
	local opt=e:GetLabel()
	if opt==0 then t=TYPE_MONSTER
	else if opt==1 then t=TYPE_SPELL
		else t=TYPE_TRAP end
	end
	Duel.ConfirmDecktop(tp,1)
	if tc:IsType(t) then 
		Duel.SendtoHand(tc,tp,REASON_EFFECT) 
		right1=1
	else 
		Duel.ShuffleDeck(tp)
	end
	opt=e:GetLabelObject():GetLabel()	
	if opt==0 then t=TYPE_MONSTER
	else if opt==1 then t=TYPE_SPELL
		else t=TYPE_TRAP end
	end
	Duel.ConfirmDecktop(1-tp,1)
	if tc2:IsType(t) then 
		Duel.SendtoHand(tc2,1-tp,REASON_EFFECT)
		right2=1
	else 
		Duel.ShuffleDeck(1-tp)
	end
	if right1==1 and right2==0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	end
end
function c200112.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetHandlerPlayer() and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end