--原初的魔女-玛利亚
function c501107.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,9,3,c501107.ovfilter,aux.Stringid(501107,1),3,c501107.xyzop)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c501107.spcon)
	e1:SetTarget(c501107.target)
	e1:SetOperation(c501107.operation)
	c:RegisterEffect(e1)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(501107,2))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c501107.target2)
	e3:SetOperation(c501107.operation2)
	c:RegisterEffect(e3)
	--战破
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(501107,3))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetCondition(c501107.incon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e6:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e6:SetCondition(c501107.incon)
	e6:SetOperation(c501107.damop)
	c:RegisterEffect(e6)
end
function c501107.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE)
		or (rp~=tp and c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==tp)
end
function c501107.incon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c501107.ovfilter(c)
	return c:IsFaceup() and not c:IsCode(501107) and c:IsSetCard(0x811) and c:IsType(TYPE_XYZ)
end
function c501107.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,501107)==0 end
	Duel.RegisterFlagEffect(tp,501107,RESET_PHASE+PHASE_END,0,1)
end
function c501107.filter(c)
	return c:IsSetCard(0x811) and c:IsAbleToHand() and c:IsType(TYPE_TRAP+TYPE_SPELL)
end
function c501107.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c501107.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c501107.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c501107.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c501107.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
end
function c501107.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
function c501107.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(1-ep,ev,false)
end

