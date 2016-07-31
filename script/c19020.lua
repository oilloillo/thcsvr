--妖精女仆✿大妖精☆
function c19020.initial_effect(c)

	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsSetCard,0xc999),aux.FilterBoolFunction(Card.IsSetCard,0xa999),true)

		--PosChange
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(19020,0))
		e1:SetCategory(CATEGORY_POSITION)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetTarget(c19020.tdtg)
		e1:SetOperation(c19020.tdop)
		c:RegisterEffect(e1)

			--search
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(19020,1))
			e2:SetCategory(CATEGORY_TOHAND)
			e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
			e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
			e2:SetCode(EVENT_LEAVE_FIELD)
			e2:SetCondition(c19020.con)
			e2:SetTarget(c19020.tg)
			e2:SetOperation(c19020.op)
			c:RegisterEffect(e2)

		--synchro limit
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e4:SetValue(c19020.synlimit)
		c:RegisterEffect(e4)

end


function c19020.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x999)
end


function c19020.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end


function c19020.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENCE,POS_FACEUP_DEFENCE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		tc:RegisterEffect(e1)
	end
end


function c19020.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
end


function c19020.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end


function c19020.mgfilter(c,tp,fusc)
	return not c:IsControler(tp)
		or not c:IsLocation(LOCATION_GRAVE)
		or c:IsHasEffect(EFFECT_NECRO_VALLEY)
		or bit.band(c:GetReason(),0x40008)~=0x40008
		or c:GetReasonCard()~=fusc
		or not c:IsAbleToHand()
end


function c19020.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	local sumable=true
	local sumtype=c:GetSummonType()
	if bit.band(sumtype,SUMMON_TYPE_FUSION)~=SUMMON_TYPE_FUSION or mg:GetCount()==0
		or mg:GetCount()>Duel.GetLocationCount(tp,LOCATION_MZONE)
		or mg:IsExists(c19020.mgfilter,2,nil,tp,c) 
		then
		sumable=false
	end
	if sumable then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=mg:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_GRAVE)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

